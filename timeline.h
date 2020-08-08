#ifndef TIMELINE_H
#define TIMELINE_H

#include <QObject>
#include <tvideo_model.h>

class TimeLine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int totalVidLen READ get_totalVidLen NOTIFY changed_totalVidLen)
    Q_PROPERTY(QAbstractListModel* model READ get_model NOTIFY changed_model)
public:
    explicit TimeLine(TVideo_Model* model, QObject* parent = nullptr);

    int get_totalVidLen();
    QAbstractListModel* get_model();

    Q_INVOKABLE int calc_width(int len, int winWidth);
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
