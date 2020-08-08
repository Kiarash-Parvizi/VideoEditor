#include "timeline.h"
#include<QtDebug>

TimeLine::TimeLine(TVideo_Model* model, QObject* parent)
    : QObject(parent)
    , model(model)
{
    connect(model, &TVideo_Model::changed_totalTime, this, &TimeLine::slot_totalVidLen);
}

int TimeLine::get_totalVidLen() {
    return model->get_totalTime();
}

void TimeLine::slot_totalVidLen() {
    qDebug() << "totalVidLen changed";
    emit changed_totalVidLen();
}

QAbstractListModel* TimeLine::get_model() {
    return model;
}

int TimeLine::calc_width(int len, int winWidth) {
    qDebug() << "calc_width";
    return winWidth * len/get_totalVidLen();
}

void TimeLine::del_VBuf(int idx) {
    model->Del(idx);
}




