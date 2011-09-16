#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>

class QDeclarativeContext;

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QDeclarativeContext *context);
    ~Controller();

public slots:
    void share(QString title, QString url, QString description);

private:
    QDeclarativeContext *m_declarativeContext;
};

#endif // CONTROLLER_H
