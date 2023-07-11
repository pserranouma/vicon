#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <windows.h>
#include "ui_mainwindow.h"
#include "pthread.h"
#include <filesystem>
#include "FTDI/ftd2xx.h"
#include <QFileDialog>
#include <QMessageBox>
#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/opencv.hpp"
#include "opencv2/objdetect/objdetect.hpp"
#include "opencv2/videoio.hpp"
#include "opencv2/face.hpp"
#include "opencv2/imgproc.hpp"

#define NumCols 640
#define NumFilas 480
#define MaxDevs 12
#define NCapturas 100
#define AddWait 3

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

using namespace cv;
using namespace cv::face;

class MainWindow : public QMainWindow
{
    Q_OBJECT
    FT_HANDLE ftHandle;
    FT_STATUS ftStatus;
    DWORD numDevs;
    UCHAR Mask = 0xff;
    UCHAR Mode;
    char *descPtr[MaxDevs+1];
    char serials[MaxDevs+1][64];
    char descriptions[MaxDevs+1][64];
    int dev=-1;
    int added;
    unsigned int Tam = NumCols * NumFilas;
    int addingWait = 0;
    unsigned char *RxBuffer, TxBuffer[1];
    CascadeClassifier face_detector;
    HANDLE threadv = NULL;
    DWORD idthread;
    QString imgdir = "C:/Qt/proyectos/tfm/images/", ruta, nombre;
    Ptr<LBPHFaceRecognizer> model;
    std::vector<std::string> nombres;

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    int PedirFrame();
    void MostrarFrame();
    void DetectarRostros();
    void ReconocerRostros();
    void MostrarFPS(float fps);

private slots:

    void on_botonConectar_clicked();

    void on_activarDeteccion_clicked(bool checked);

    void on_guardarImagen_clicked();

    void on_guardarVideo_clicked();

    void on_activarColor_clicked(bool checked);

    void on_activarReconocimiento_clicked(bool checked);

    void on_addPersona_clicked();

    void cargarImagenes();

private:
    Ui::MainWindow *ui;

};
#endif // MAINWINDOW_H
