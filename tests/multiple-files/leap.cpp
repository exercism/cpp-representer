#include "leap.h"

namespace leap
{

    bool is_leap_year(int y)
    {
        auto divBy = [=](int div)
        { return y % div == 0; };
        return divBy(4) && (!divBy(100) || divBy(400));
    }

}