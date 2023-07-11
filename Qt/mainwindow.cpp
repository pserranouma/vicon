#include "mainwindow.h"

char serial[]="FT7XBJ6M";
boolean conectado = false, detectar = false, reconocer =false, guardando = false, color = false;
int adding = -1;
DWORD startTime,endTime,fStartTime,fEndTime,currentTime;
Mat image;
VideoWriter *outputVideo;
int fpsVideo = 10;


///////////////////////////////////////////////////////////////////////
/// método para manejar el evento de pulsación del botón Conectar
/// \brief MainWindow::cargarImagenes
///////////////////////////////////////////////////////////////////////

void MainWindow::cargarImagenes()
{
    std::vector<int> ids;
    std::vector<Mat> muestras;
    Mat cara;
    int id = 0;

    // buscamos en la carpeta de imágenes
    for (const auto &file : std::filesystem::directory_iterator(imgdir.toStdString()))
    {
        std::string nombredir = file.path().filename().string();
        if (std::filesystem::is_directory(file.path()))
        {
            // añadimos las caras almacenadas para cada persona
            for (const auto &f : std::filesystem::directory_iterator(file.path())) {
                cara = imread(f.path().string(), IMREAD_GRAYSCALE);
                muestras.emplace_back(cara);
                ids.emplace_back(id);  
            }
            nombres.emplace_back(nombredir);
            id++;
        }
    }
    // entrenamos el sistema
    if (muestras.size() != 0) model->train(muestras, ids);
}


///////////////////////////////////////////////////////////////////////
/// contructor de la clase
/// \brief MainWindow::MainWindow
/// \param parent
///////////////////////////////////////////////////////////////////////

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    QString name;

    ui->setupUi(this);
    ui->statusbar->showMessage("Desconectado");

    ui->imagen->setStyleSheet("QLabel { background-color : black; }");

    RxBuffer = new unsigned char[2 * Tam];
    ftStatus = FT_ListDevices(&numDevs,NULL,FT_LIST_NUMBER_ONLY);
    if (ftStatus == FT_OK)
    {
        for (DWORD i=0; i<numDevs; i++)
        {
            ftStatus = FT_ListDevices((PVOID)i,serials[i],FT_LIST_BY_INDEX|FT_OPEN_BY_SERIAL_NUMBER);
            descPtr[i]=descriptions[i];
            name = QString(serials[i]);
            if (name.isEmpty()) name = "N/A";
            ui->selectDisp->addItem(name);
            if (QString(serials[i])==QString(serial))
                ui->selectDisp->setCurrentIndex(i);
        }
    }
    else  // Si falla FT_ListDevices
    {
        ui->statusbar->showMessage("Desconectado. Error al listar dispositivos.");
    }

    // inicializamos el detector de caras con los datos precalculados
    String facedetector_data = "C:/opencv/sources/data/haarcascades/haarcascade_frontalface_alt2.xml";
    if( !face_detector.load(facedetector_data) )
    {
        ui->statusbar->showMessage("Desconectado. Error al cargar face detector");
    }

    // inicializamos el modelo del reconocedor facial
    model = cv::face::LBPHFaceRecognizer::create();
    // cargamos las imágenes de entrenamiento
    cargarImagenes();
}


///////////////////////////////////////////////////////////////////////
/// destructor de la clase
/// \brief MainWindow::~MainWindow
///////////////////////////////////////////////////////////////////////

MainWindow::~MainWindow()
{
    if (threadv != NULL) TerminateThread(threadv, 0);
    delete ui;
}


///////////////////////////////////////////////////////////////////////
/// método para solicitar los datos de un frame a la FPGA
/// \brief MainWindow::PedirFrame
///////////////////////////////////////////////////////////////////////
int MainWindow::PedirFrame()
{
    DWORD RxBytes,TxBytes;
    DWORD EventDWord;
    DWORD BytesReceived,BytesWritten;
    DWORD total=0;

    if (!color)
    {
        TxBuffer[0]=1;
        Tam = NumCols * NumFilas;
    }
    else
    {
        TxBuffer[0]=2;
        Tam = 2 * NumCols * NumFilas;
    }
    // mandamos el código adecuado a la FPGA:
    ftStatus = FT_Write(ftHandle,TxBuffer,1,&BytesWritten);
    if (ftStatus == FT_OK)
    {
        fStartTime = GetTickCount();
        while (total < Tam)
        {
            // vemos si hay datos disponibles en el USB:
            ftStatus = FT_GetStatus(ftHandle,&RxBytes,&TxBytes,&EventDWord);
            if ((ftStatus == FT_OK) && (RxBytes > 0))
            {
                if ((total+RxBytes) > Tam)  // error
                {
                    RxBytes = Tam-total;
                }
                // leemos los datos disponibles desde el USB:
                ftStatus = FT_Read(ftHandle,RxBuffer+total,RxBytes,&BytesReceived);
                if (ftStatus == FT_OK)  // FT_Read OK
                {
                    total += BytesReceived;
                    if (total == Tam)  // se ha leido el frame completo
                    {
                        break;
                    }
                    else if (total > Tam)  // error
                    {
                        FT_Purge(ftHandle, FT_PURGE_RX|FT_PURGE_TX);
                        return -1;
                    }
                }
            }
            currentTime = GetTickCount();
            if ((currentTime - fStartTime) > 1000)
                break;
        }
    }

    // guardamos los datos leídos como imagen, en el formato adecuado:
    if (!color)
    {
       image = Mat(NumFilas, NumCols, CV_8UC1, (void *)RxBuffer);
    }
    else
    {
        Mat image2 = Mat(NumFilas, NumCols, CV_8UC2, (void *)RxBuffer);
        cvtColor(image2, image, COLOR_YUV2RGB_UYVY);
        int c=image.channels();
    }

    return 0;
}

///////////////////////////////////////////////////////////////////////
/// método para mostrar los Frames por segundo del vídeo capturado
/// \brief MainWindow::MostrarFPS
/// \param fps: frames por segundo
///////////////////////////////////////////////////////////////////////

void MainWindow::MostrarFPS(float fps)
{
    QString n;

    n = QString::asprintf("%.1f", fps);
    ui->labelFPS->setText(n);
}


///////////////////////////////////////////////////////////////////////
/// thread para mostrar el vídeo capturado
/// \brief MostrarVideo
/// \param lpParam: parámetro de entrada
///////////////////////////////////////////////////////////////////////

DWORD WINAPI MostrarVideo(LPVOID lpParam)
{
    MainWindow *mw = (MainWindow *)lpParam;
    int numFrames = 0;
    Mat out;

    startTime = GetTickCount();
    while(conectado)
    {
        mw->PedirFrame();
        if (detectar || (adding != -1))
        {
            mw->DetectarRostros();
        }
        mw->MostrarFrame();
        if (guardando)  // para el caso de que tengamos que almacenar el frame mostrado
        {
            if (!color)
            {
                cvtColor(image, out, COLOR_GRAY2RGB);
                *outputVideo << out;
            }
            else
            {
                *outputVideo << image;
            }
        }
        numFrames++;
        endTime = GetTickCount();
        fpsVideo = numFrames*1000 / (endTime - startTime);
        mw->MostrarFPS((float)numFrames*1000 / (endTime - startTime));
    }
    return 0;
}


///////////////////////////////////////////////////////////////////////
/// método para mostrar un Frame capturado
/// \brief MainWindow::MostrarFrame
///////////////////////////////////////////////////////////////////////

void MainWindow::MostrarFrame()
{
    QImage img;
    if (!color)
    {
        img = QImage(image.data, NumCols, NumFilas, QImage::Format_Grayscale8);
    }
    else
    {
        img = QImage(image.data, NumCols, NumFilas, QImage::Format_RGB888);
    }
    ui->imagen->setPixmap(QPixmap::fromImage(img));
}


///////////////////////////////////////////////////////////////////////
/// método para detectar y reconocer rostros
/// \brief MainWindow::DetectarRostros
///////////////////////////////////////////////////////////////////////

void MainWindow::DetectarRostros()
{
    std::vector<Rect> faces;
    Mat imageg, face, resized;
    QString filename;
    int prediccion;
    double confianza;

    if (color) cvtColor(image, imageg, COLOR_RGB2GRAY);
    else imageg = image;
    if (adding != -1)  // añadir rostro conocido
    {
        face_detector.detectMultiScale(imageg, faces, 1.1, 3, 0, Size(300,300), Size(480,480));
        if (faces.size() == 1)  // solo añadimos si encontramos una unica cara
        {
            if (addingWait++ == 0)  // esperamos AddWait imágenes entre captura y captura
            {
                face = imageg(Rect(faces.at(0).x, faces.at(0).y, faces.at(0).width, faces.at(0).height));
                cv::resize(face, resized, Size(100, 100));
                filename = ruta + "/" + QString::number(adding + added) + ".jpg";
                imwrite(filename.toStdString(), resized);
                if (++added == NCapturas)  // número de capturas que queremos almacenar
                {
                    adding = -1;
                    cargarImagenes();  // rehacemos el modelo
                }
            }
            else if (addingWait == AddWait)
            {
                addingWait = 0;
            };
        }
    }
    else
    {
        face_detector.detectMultiScale(image, faces, 1.1, 3, 0, Size(100,100), Size(480,480));
        for (int i=0; i<faces.size(); i++)
        {
            if (reconocer) {
                rectangle(image, Point(faces.at(i).x,faces.at(i).y), Point(faces.at(i).x+faces.at(i).width,faces.at(i).y+faces.at(i).height), Scalar(0,255,0), 3);
                face = imageg(Rect(faces.at(i).x, faces.at(i).y, faces.at(i).width, faces.at(i).height));
                cv::resize(face, resized, Size(100, 100));
                prediccion = -1;
                confianza = 0.0;
                model->predict(face, prediccion, confianza);
                if (prediccion != -1)  // se ha podido encontrar una distancia entre la cara detectada y las muestras con las que se entrenó el modelo
                {
                    if (confianza < 80.8)  // distancia
                    {
                        putText(image, nombres[prediccion], Point(faces.at(i).x+5,faces.at(i).y-5), FONT_HERSHEY_DUPLEX, 1, Scalar(0,255,0));
                    }
                }
            }
            else rectangle(image, Point(faces.at(i).x,faces.at(i).y), Point(faces.at(i).x+faces.at(i).width,faces.at(i).y+faces.at(i).height), Scalar(0,255,0), 3);
        }
    }
}


///////////////////////////////////////////////////////////////////////
/// método para manejar el evento de pulsación del botón Conectar
/// \brief MainWindow::on_botonConectar_clicked
///////////////////////////////////////////////////////////////////////

void MainWindow::on_botonConectar_clicked()
{
    if (!conectado) {  // conectar:
        dev=ui->selectDisp->currentIndex();
        if (dev==-1)
        {  // No se ha encontrado el dispositivo especificado
            ui->statusbar->showMessage("Desconectado. Dispositivo no encontrado.");
        }
        ftStatus = FT_Open(dev, &ftHandle);
        if(ftStatus != FT_OK)
        {  // Falla FT_Open
            ui->statusbar->showMessage("Desconectado. No se ha podido establecer conexión.");
        }
        else  // inicializamos el conversor USB:
        {
            conectado = true;
            ui->botonConectar->setText("Desconectar");
            ui->statusbar->showMessage("Conectado");
            FT_ResetDevice(ftHandle);
            FT_SetLatencyTimer(ftHandle, 2);
            FT_SetUSBParameters(ftHandle,0x10000, 0x10000);
            FT_SetFlowControl(ftHandle, FT_FLOW_RTS_CTS, 0x0, 0x0);
            FT_Purge(ftHandle, FT_PURGE_RX|FT_PURGE_TX);
            threadv = CreateThread(NULL, 0, MostrarVideo, this, 0, &idthread);
        }
    }
    else {  // desconectar:
        conectado = false;
        ftStatus = FT_Close(ftHandle);
        if(ftStatus != FT_OK)
        {  // Falla FT_Open
            ui->statusbar->showMessage("Error. No se ha podido cerrar la conexión.");
        }
        else
        {
            ui->statusbar->showMessage("Desconectado");
            ui->botonConectar->setText("Conectar");
        }
    }
}


///////////////////////////////////////////////////////////////////////
/// método para manejar el evento de pulsación del check activar detección
/// \brief MainWindow::on_activarDetección_clicked
/// \param checked
///////////////////////////////////////////////////////////////////////

void MainWindow::on_activarDeteccion_clicked(bool checked)
{
    detectar = checked;
}


///////////////////////////////////////////////////////////////////////
/// método para manejar el evento de pulsación del botón guardar imagen
/// \brief MainWindow::on_guardarImagen_clicked
///////////////////////////////////////////////////////////////////////

void MainWindow::on_guardarImagen_clicked()
{
    QString nombre;
    Mat captura;

    image.copyTo(captura);
    nombre = QFileDialog::getSaveFileName(this, "Guardar imagen", "", "*.jpg");
    if (!nombre.isEmpty())
    {
        imwrite(nombre.toStdString(), captura);
    }
}


///////////////////////////////////////////////////////////////////////
/// método para manejar el evento de pulsación del botón guardar vídeo
/// \brief MainWindow::on_guardarVideo_clicked
///////////////////////////////////////////////////////////////////////

void MainWindow::on_guardarVideo_clicked()
{
    QString nombre;
    Mat captura;

    if (!guardando) {
        nombre = QFileDialog::getSaveFileName(this, "Guardar vídeo", "", "*.avi");
        if (!nombre.isEmpty())
        {
            outputVideo = new VideoWriter();
            int ex = VideoWriter::fourcc('M','J','P','G');  // Codec Type- Int form
            Size S = Size((int) NumCols, (int) NumFilas);

            // Grabar salida de video
            outputVideo->open(nombre.toStdString(), ex, fpsVideo, S, true);
            if (outputVideo->isOpened())
            {
                guardando = true;
                ui->guardarVideo->setText("Parar grabación");
            }
            else
            {
                delete outputVideo;
            }
        }
    }
    else
    {
        guardando = false;
        delete outputVideo;
        ui->guardarVideo->setText("Guardar vídeo");
    }
}


///////////////////////////////////////////////////////////////////////
/// método para manejar el evento de pulsación del check activar color
/// \brief MainWindow::on_activarColor_clicked
/// \param checked
///////////////////////////////////////////////////////////////////////

void MainWindow::on_activarColor_clicked(bool checked)
{
    DWORD RxBytes,TxBytes;
    DWORD EventDWord;
    DWORD BytesReceived;

    if (threadv != NULL)
    {
        // finalizamos el thread actual
        TerminateThread(threadv, 0);
        WaitForSingleObject(threadv, INFINITE);
        // leemos los datos recibidos por USB, si quedan
        do {
            ftStatus = FT_GetStatus(ftHandle,&RxBytes,&TxBytes,&EventDWord);
            if ((ftStatus == FT_OK) && (RxBytes > 0))
            {
                FT_Read(ftHandle,RxBuffer,RxBytes,&BytesReceived);
            }
        } while (RxBytes != 0);
        FT_Purge(ftHandle, FT_PURGE_RX|FT_PURGE_TX);
    }
    color = checked;
    if (conectado)
    {
        // creamos un nuevo thread para mostrar el vídeo capturado
        threadv = CreateThread(NULL, 0, MostrarVideo, this, 0, &idthread);
    }
}


///////////////////////////////////////////////////////////////////////
/// método para manejar el evento de pulsación del check activar reconocimiento
/// \brief MainWindow::on_activarReconocimiento_clicked
/// \param checked
///////////////////////////////////////////////////////////////////////

void MainWindow::on_activarReconocimiento_clicked(bool checked)
{
    reconocer = checked;
}


///////////////////////////////////////////////////////////////////////
/// método para añadir una nueva persona al sistema de reconocimiento facial
/// \brief MainWindow::on_addPersona_clicked
///////////////////////////////////////////////////////////////////////

void MainWindow::on_addPersona_clicked()
{
    std::filesystem::path filepath;

    if (adding == -1)
    {
        nombre = ui->nombrePersona->text();
        ui->nombrePersona->setText("");
        ruta = imgdir + nombre;
        filepath = ruta.toStdString();
        // verificamos si ya hay una persona con ese nombre añadida al sistema:
        if (std::filesystem::is_directory(filepath))
        {
            int n = std::distance(std::filesystem::directory_iterator(filepath), {});
            adding = n;
            added = 0;
        }
        else  // creamos una carpeta para almacenar los rostros y comenzamos a capturarlos:
        {
            if (std::filesystem::create_directory(filepath))
            {
                adding = 0;
                added = 0;
            }
        }
    }
}
