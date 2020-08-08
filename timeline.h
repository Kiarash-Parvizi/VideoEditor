#ifndef TIMELINE_H
#define TIMELINE_H

#include <QObject>
#include <tvideo_model.h>

#define ull unsigned long long

class TimeLine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ull totalVidLen READ get_totalVidLen NOTIFY changed_totalVidLen)
    Q_PROPERTY(QAbstractListModel* model READ get_model NOTIFY changed_model)
public:
    explicit TimeLine(TVideo_Model* model, QObject* parent = nullptr);

    ull get_totalVidLen();
    QAbstractListModel* get_model();

    Q_INVOKABLE ull calc_width(ull len, ull winWidth);
    Q_INVOKABLE void ins_Buf(const QString& source, ull start, ull end, ull vTime);
    Q_INVOKABLE void del_VBuf(int idx);

public slots:
    void slot_totalVidLen();

signals:
    void changed_totalVidLen();
    void changed_model();

private:
    TVideo_Model* model;
};

#endif // TIMELINE_H
