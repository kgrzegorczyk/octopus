#include <vector>
#include "foo1.h"
#include "foo2.hpp"

int main(void)
{
    std::vector<int> v;
    foo1();
    foo2();

    return 0;
}
