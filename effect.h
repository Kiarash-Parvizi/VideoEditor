#ifndef EFFECT_H
#define EFFECT_H

#include<QString>
#define ll long long

class Effect {
public:
    virtual ~Effect() = 0;
    virtual QString get_command(int i1, int i2) const = 0;
    virtual Effect* clone() = 0;
protected:
    QString command;
};

inline Effect::~Effect() {}

#endif // EFFECT_H
