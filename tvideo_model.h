#ifndef TVIDEO_MODEL_H
#define TVIDEO_MODEL_H

#include <QAbstractListModel>
#include<QObject>

class TVideo_Model : public QAbstractListModel
{
    Q_OBJECT

    struct ModelItem {
        QString _source;
        int len, start, end;
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
    void Del(int idx);

signals:
    void changed_totalTime();

public slots:
    void setItemData2(int index, QVariant value, QString role);

private:
    int totalTime = 0;
    QVector<ModelItem> v;

private:
    void CreateDefaultModel();
    void set_totalTime(int);
    void inc_totalTime(int);
};

#endif // TVIDEO_MODEL_H




