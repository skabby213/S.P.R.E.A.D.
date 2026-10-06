#include <iostream>
#include "httplib.h"

int main()
{
    httplib::Server server;

    server.Get("/health", [](const httplib::Request& req, httplib::Response& res) {
    res.set_content(
        R"({"status":"ok","service":"S.P.R.E.A.D. API"})",
        "application/json"
    );
});

   server.Get(R"(/api/products/(\d+))", [](const httplib::Request& req, httplib::Response& res) {

    std::string product_id = req.matches[1];

    std::string json =
        "{\"product_id\":" + product_id +
        ",\"product_name\":\"Chicken Breast\","
        "\"status\":\"safe\"}";

    res.set_content(json, "application/json");
});

    std::cout << "S.P.R.E.A.D. API running on port 8080..." << std::endl;

    server.Get(R"(/api/lots/(\d+))", [](const httplib::Request& req, httplib::Response& res) {

    std::string lot_id = req.matches[1];

    std::string json =
        "{\"lot_id\":" + lot_id +
        ",\"lot_code\":\"LOT-2026-001\","
        "\"status\":\"active\"}";

    res.set_content(json, "application/json");
});

    server.listen("0.0.0.0", 8080);

    return 0;
}