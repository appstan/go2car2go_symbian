#include "utils.h"
#include <QtCore/QMetaObject>
#include <QtCore/QMetaProperty>
#include <QtCore/QStringList>
#include <QtGlobal>
#include <QCryptographicHash>
#include <math.h>

//TODO: conditional compilation module instead of ifdef's
#ifdef Q_OS_SYMBIAN
#include <eikenv.h>
#include <coemain.h>
#include <aknappui.h>
#endif

#ifndef Q_WS_WIN
#ifndef Q_WS_MAC
#include <QSystemDeviceInfo>
QTM_USE_NAMESPACE
#endif
#endif

namespace Utils {

    static const double EARTH_RADIUS_IN_METER  = 6371000.0;
    static const double EARTH_RADIUS_IN_MILES  = 3690.0;
    static const double EARTH_RADIUS_IN_KM     = 6371.0;
    static const double Pi = 3.14159265358979323846264338327950288419717;
    static const double DEG_TO_RAD = 0.017453292519943295769236907684886;



int environment()
{
    int result = 0;
#if defined(Q_WS_X11)
    result = LINUX;
#elif defined(Q_WS_S60)
    result = SYMBIAN;
#elif defined(Q_WS_WIN)
    result = WINDOWS;
#elif defined(Q_WS_MAEMO)
    result = MAEMO;
#elif defined(Q_WS_MAC)
    result = OSX;
#endif

    return result;
}


bool requireLogin()
{
    return true;
}

double calculateDistance(double latFrom, double lonFrom, double latTo, double lonTo)
{
    double rho = EARTH_RADIUS_IN_METER;

    double phi_1 = (90.0 - latFrom)*DEG_TO_RAD;
    double phi_2 = (90.0 - latTo)*DEG_TO_RAD;

    double theta_1 = lonFrom*DEG_TO_RAD;
    double theta_2 = lonTo*DEG_TO_RAD;

    double distance = rho*acos(sin(phi_1)*sin(phi_2)*cos(theta_1 - theta_2) + cos(phi_1)*cos(phi_2));
    return round(distance);
}


}
