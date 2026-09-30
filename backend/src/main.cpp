#include <iostream>
#include "httplib.h"

int main()
{
    httplib::Server server;

    server.Get("/health", [](const httplib::Request& req, httplib::Response& res) {
        res.set_content(
            R"({"status":"ok","service":"SPREAD API"})",
            "application/json"
        );
    });

    std::cout << "S.P.R.E.A.D. API running on port 8080..." << std::endl;

    server.listen("0.0.0.0", 8080);

    return 0;
}