#ifndef TVIDEO_MODEL_H
#define TVIDEO_MODEL_H

#include <QAbstractListModel>
#include<QObject>

#define ull unsigned long long

class TVideo_Model : public QAbstractListModel
{
    Q_OBJECT

    struct ModelItem {
        QString _source;
        ull len, start, end;
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
    void Insert(const ModelItem&, ull vTime);
    void Del(int idx);

signals:
    void changed_totalTime();

public slots:
    void setItemData2(int index, QVariant value, QString role);

private:
    ull totalTime = 0;
    QVector<ModelItem> v;

private:
    void CreateDefaultModel();
    void set_totalTime(ull);
    void inc_totalTime(ull);
};

#endif // TVIDEO_MODEL_H




