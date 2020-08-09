#ifndef TVIDEO_MODEL_H
#define TVIDEO_MODEL_H

#include <QAbstractListModel>
#include<QObject>
#include<functional>

#define ll long long

class TVideo_Model : public QAbstractListModel
{
    Q_OBJECT

    struct ModelItem {
        QString _source;
        ll len, start, end;
        void calcLen() {
            len = end - start;
        }
        void set_start(ll v) {
            start = v; calcLen();
        }
        void set_end(ll v) {
            end   = v; calcLen();
        }
    };
    enum { name=Qt::UserRole, _source, len, start, end };

public:
    explicit TVideo_Model(QObject *parent = nullptr);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    int get_totalTime();

    // Add Item
    void Add(const ModelItem&);
    void Insert(const ModelItem&, int loc);
    void Insert_Buf(const ModelItem&, ll vTime);
    void Rem_inclusive(int s, int e);
    void Del(int idx);

    // setup
    void set_emitStateChanged_func(const std::function<void()>&);

    // Edit
    void cut_interval(ll start, ll end);

signals:
    void changed_totalTime();

public slots:
    void setItemData2(int index, QVariant value, QString role);

private:
    std::function<void()> emitStateChanged;
    ll totalTime = 0;
    QVector<ModelItem> v;

private:
    void CreateDefaultModel();
    void set_totalTime(ll);
    void inc_totalTime(ll);
};

#endif // TVIDEO_MODEL_H




