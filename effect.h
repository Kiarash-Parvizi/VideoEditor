#ifndef EFFECT_H
#define EFFECT_H

#include<QString>
#include<fstream>
#define ll long long

class Effect {
public:
    virtual ~Effect() = 0;
    virtual const QString& get_command(int i1, int i2) = 0;
    virtual Effect* clone() = 0;
    virtual void read_data(std::ifstream& in) = 0;
    virtual void write_data(std::ofstream& out) = 0;
protected:
    QString command;
};

inline Effect::~Effect() {}

#endif // EFFECT_H
