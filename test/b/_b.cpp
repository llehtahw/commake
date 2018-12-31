#include <iostream>
namespace {
    auto b = []() {
        std::cout << "hello from " << __FILE__ << std::endl;
        return 233;
    }();
}
