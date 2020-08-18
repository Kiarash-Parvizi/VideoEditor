#ifndef EFFECT_H
#define EFFECT_H

#include<QString>
#define ll long long

class Effect {
public:
    virtual const QString& get_command() = 0;
protected:
    QString command;
};

#endif // EFFECT_H
