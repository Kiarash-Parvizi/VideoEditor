#ifndef UTIL_H
#define UTIL_H

#include<thread>
#include<chrono>
#include<functional>
#include<QDebug>
#include<QVector>

#define ll long long

// Invoke
template <class F, class... Args>
void invoke(F &&f, ll interval, Args &&... args) {
    auto task = std::make_shared<std::function<void()>>(
        std::bind(std::forward<F>(f), std::forward<Args>(args)...));
    //
    std::thread([task, interval]() {
        std::this_thread::sleep_for(std::chrono::milliseconds(interval));
        qDebug() << "before running";
        (*task)();
    }).detach();
}

#endif // UTIL_H
