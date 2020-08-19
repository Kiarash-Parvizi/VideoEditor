#ifndef TVIDEO_MODEL_H
#define TVIDEO_MODEL_H

#include <QAbstractListModel>
#include<QObject>
#include<functional>
#include<Effects_List.h>

#define ll long long


class TVideo_Model : public QAbstractListModel
{
    Q_OBJECT

    enum { name=Qt::UserRole, _source, len, start, end, hasAudio };

public:
    // ModelItem
    struct ModelItem {
        QString _source;
        ll len, start, end;
        bool hasAudio = true;
        //
        QVector<Effect*> effects;
        // Funcs
        void calcLen() {
            len = end - start;
        }
        void set_start(ll val) {
            start = val; calcLen();
        }
        void set_end(ll val) {
            end   = val; calcLen();
        }
        // save
        void save(std::ofstream& out) {
            using namespace std;
            out << _source.toUtf8().constData() << "\" " << len << " " << start << " " << end << " " << hasAudio << " ";
            out << effects.size() << " ";
            for (const auto e : effects) {
                e->write_data(out);
            }
        }
        // load
        void load(std::ifstream& iF) {
            using namespace std;
            string s; s.reserve(32);
            string src; src.reserve(64);
            do {
                iF >> s; src += s;
            } while(s[s.size()-1] != '\"');
            src.erase(src.end()-1);
            _source = QString::fromStdString(src);
            //
            iF >> len >> start >> end >> hasAudio;
            // effects
            int efCount; iF >> efCount;
            effects = QVector<Effect*>(efCount);
            for (auto& val : effects) {
                val->read_data(iF);
            }
        }
    };
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
    ll Rem_inclusive(int s, int e, bool useIncFunc = true);
    void Del(int idx);

    // util
    int getIdx(ll vtime);

    //
    void trim(ll minLen);
    void add_blur(ll vTime, int x, int y, int w, int h);
    void set_hasAudio(int idx);

    const QVector<ModelItem>* getModelVec() const {
        return &v;
    }
    void force_resetModel(int size) {
        // You need
        //beginResetModel();
        //v.clear();
        //endResetModel();

        //beginInsertRows(QModelIndex(),0,v.size());

        //v = QVector<ModelItem>(size);
        //qDebug() << "insert done : " << v.size();

        //endInsertRows();
    }
    void emit_everythingChanged() {
        emit dataChanged(createIndex(0,0), createIndex(v.size()-1,0), {_source, len, start, end, hasAudio });
    }

    // setup
    void set_emitStateChanged_func(const std::function<void()>&);

    // Edit
    void cut_interval(ll start, ll end);

signals:
    void changed_totalTime(ll totalTime);

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




