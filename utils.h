
#ifndef __M_UTILS__
#define __M_UTILS__

#include <QString>

class QMetaObject;
class QStringList;

namespace Utils {

typedef enum { PORTRAIT, LANDSCAPE, AUTO } Orientation;
typedef enum { LINUX, SYMBIAN, MAEMO, WINDOWS, OSX } Environment;


static const char PropertyPrefix[] = "db_";

double calculateDistance(double latFrom, double lonFrom, double latTo, double lonTo);

int environment();

bool requireLogin();


}

#endif
