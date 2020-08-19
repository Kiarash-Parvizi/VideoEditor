#include "blur.h"

Blur::Blur() {}

Blur::Blur(int x, int y, int w, int h)
    : x(x)
    , y(y)
    , w(w)
    , h(h)
{
}

Blur::~Blur() {
}

Effect* Blur::clone() {
    qDebug() << "Blur::clone";
    return new Blur(x, y, w, h);
}

void Blur::read_data(std::ifstream& in) {
    in >> x >> y >> w >> h;
}

void Blur::write_data(std::ofstream &out) {
    out << x << " " << y << " " << w << " " << h << " ";
}

const QString& Blur::get_command(int i1, int i2) {
    qDebug() << "get_command";
    QString inp;
    if (i2 == 0) {
        inp = QString("v")+QString::number(i1);
    } else {
        inp = QString("v")+QString::number(i1)+"_"+QString::number(i2-1);
    }
    qDebug() << "Stage1";
    QString iden = inp + "__" + QString::number(i2);
    QString sub0= iden+"_sub0";
    QString sub1= iden+"_sub1";
    QString out0= iden+"_out0";
    QString out = QString("v")+QString::number(i1)+"_"+QString::number(i2);
    // asn & return
    command = QString("[")+inp+"]split=2["+sub0+"]["+sub1+"];["+sub1+"]crop="+
        QString::number(w)+":"+QString::number(h)+":"+QString::number(x)+":"+QString::number(y)+
        ",boxblur=10["+out0+"];["+sub0+"]["+out0+"]overlay="+QString::number(x)+":"+QString::number(y)+"["+out+"]";
    return command;
}
