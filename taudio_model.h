#ifndef TAUDIO_MODEL_H
#define TAUDIO_MODEL_H

#include<QAbstractListModel>
#include<QObject>
#include<QDebug>

#define ll long long


class TAudio_Model : public QAbstractListModel
{
    Q_OBJECT

    struct ModelItem {
        QString _source;
        ll len, medStart, medEnd;
        double sPosRatio = 0;
        //
        ModelItem() {}
        ModelItem(QString src, ll medStart, ll medEnd)
            : _source(src)
            , medStart(medStart)
            , medEnd(medEnd)
        {
            calcLen();
        }
        // setters
        void set_medStart(ll v) {
            medStart = v; calcLen();
        }
        void set_medEnd(ll v) {
            medEnd = v; calcLen();
        }
        void set_sPosRatio(double v) {
            sPosRatio = v;
        }
    private:
        void calcLen() {
            len = medEnd - medStart;
        }
    };
    enum { name=Qt::UserRole, _source, len, medStart, medEnd, sPosRatio };

public:
    // qml setters
    void set_sPosRatio(int idx, double val);

    // Add Item
    void add_buf(const QString& src, ll medStart, ll medEnd);

    //
    explicit TAudio_Model(QObject *parent = nullptr);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

public slots:
    void setItemData2(int index, QVariant value, const QString& role);
    void set_totalVideoLen(ll v);

private:
    void arrange();
    bool placedOk();
    double calcPlace(ll len);
    //
    void Add(const TAudio_Model::ModelItem&);
    void Del(int idx);

private:
    QVector<ModelItem> v;
    ll totVideoLen = 0;
    ll totLen = 0;
};


#endif // TAUDIO_MODEL_H
