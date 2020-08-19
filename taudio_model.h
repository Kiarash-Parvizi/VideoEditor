#ifndef TAUDIO_MODEL_H
#define TAUDIO_MODEL_H

#include<QAbstractListModel>
#include<QObject>
#include<QDebug>
#include<fstream>

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
        // save
        void save(std::ofstream& out) {
            using namespace std;
            out << _source.toUtf8().constData() << "\" " << len << " " << medStart << " " << medEnd << " " << sPosRatio << " ";
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
            iF >> len >> medStart >> medEnd >> sPosRatio;
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
    void rem_buf(int idx);

    //
    void trim(ll minLen);
    //
    const QVector<ModelItem>* getModelVec() const {
        return &v;
    }
    void force_resetModel(int size) {
        beginResetModel();
        v = QVector<ModelItem>(size);
        endResetModel();
    }
    void emit_everythingChanged() {
        emit dataChanged(createIndex(0,0), createIndex(v.size()-1,0), { _source, len, medStart, medEnd, sPosRatio });
    }

    //
    explicit TAudio_Model(QObject *parent = nullptr);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

public slots:
    void setItemData2(int index, QVariant value, const QString& role);
    void set_totalVideoLen(ll v);

private:
    void rearrange();
    bool placedOk();
    void checkPlace();
    double calcPlace(ll len);
    //
    void Add(const TAudio_Model::ModelItem&);
    //
    void inc_totLen(ll amount);

private:
    QVector<ModelItem> v;
    ll totVideoLen = 0;
    ll totLen = 0;
};


#endif // TAUDIO_MODEL_H
