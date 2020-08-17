#ifndef TIMELINE_H
#define TIMELINE_H

#include <QObject>
#include<QtDebug>
#include <tvideo_model.h>
#include <taudio_model.h>

#define ll long long

class TimeLine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool stateTrigger READ get_stateTrigger NOTIFY changed_stateTrigger)
    Q_PROPERTY(ll totalVidLen READ get_totalVidLen NOTIFY changed_totalVidLen)
    Q_PROPERTY(QAbstractListModel*  model READ  get_model NOTIFY changed_model)
    Q_PROPERTY(QAbstractListModel* aModel READ get_aModel NOTIFY changed_aModel)
public:
    explicit TimeLine(TVideo_Model* model, TAudio_Model* aModel, QObject* parent = nullptr);

    ll get_totalVidLen();
    bool get_stateTrigger() {
        return stateTrigger;
    }
    void stateChanged() {
        stateTrigger = !stateTrigger;
        emit changed_stateTrigger();
    }
    QAbstractListModel* get_model();
    QAbstractListModel* get_aModel();

    Q_INVOKABLE double calc_width(ll len, int winWidth);
    Q_INVOKABLE void ins_Buf(const QString& source, ll start, ll end, ll vTime);
    Q_INVOKABLE void del_VBuf(int idx);
    //
    Q_INVOKABLE void add_aaudioBuf(const QString& src, ll medStart, ll medEnd);
    Q_INVOKABLE void set_aaudio_sPosRatio(int idx, double val);

    //
    //Q_INVOKABLE void add_ABuf(const QString& source, ll start, ll end);
    //Q_INVOKABLE void add_effect();
    Q_INVOKABLE void trim(ll minLen);

    //Edit
    Q_INVOKABLE void cut_interval(ll start, ll end);

public slots:
    void slot_totalVidLen();

signals:
    void changed_totalVidLen();
    void changed_model();
    void changed_aModel();
    void changed_stateTrigger();

private:
    TVideo_Model* model;
    TAudio_Model* aModel;
    bool stateTrigger;
};

#endif // TIMELINE_H
