#include "handlehumiture.h"
#include <QtDebug>

HandleHumiture::HandleHumiture(QObject *parent) : QObject(parent)
{

}

void HandleHumiture::onQueryRecord(int deviceAddr, QDate date)
{
    qDebug() << "deviceAddr: " << deviceAddr << ", date: " << date;
}

void HandleHumiture::onOpenCom(QString com, int baud)
{
    qDebug() << "Com: " << com << ", baud: " << baud;
//    emit comOpenResult(baud, 1, "N", 8);
}

void HandleHumiture::onCloseCom()
{
    qDebug() << "Close Com;";
}

void HandleHumiture::onReadHumiture(int deviceAddr, int registerAddr, int registerLen)
{
    qDebug() << "deviceAddr: " << deviceAddr << ", registerAddr: "
             << registerAddr << ", registerLen: " << registerLen;
}

void HandleHumiture::onTimesReadHumiture(int deviceStartAddr, int deviceStopAddr,
                                         int registerAddr, int registerLen, int times)
{
    qDebug() << "deviceStartAddr: " << deviceStartAddr << ", deviceStopAddr: "
             << deviceStopAddr << ", registerAddr: " << registerAddr
             << ", registerLen: " << registerLen << ", times: " << times;
}

void HandleHumiture::onReadCmd(int deviceAddr, int registerAddr, int registerLen)
{
    qDebug() << "deviceAddr: " << deviceAddr << ", registerAddr: "
             << registerAddr << ", registerLen: " << registerLen;
}

void HandleHumiture::onModifyCmd(int deviceAddr, int registerAddr, int data)
{
    qDebug() << "deviceAddr: " << deviceAddr << ", registerAddr: "
             << registerAddr << ", data: " << data;
}
