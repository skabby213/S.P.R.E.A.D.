#include <iostream>
#include "httplib.h"

int main()
{
    httplib::Server server;

   server.Get(R"(/api/products/(\d+))", [](const httplib::Request& req, httplib::Response& res) {

    std::string product_id = req.matches[1];

    std::string json =
        "{\"product_id\":" + product_id +
        ",\"product_name\":\"Chicken Breast\","
        "\"status\":\"safe\"}";

    res.set_content(json, "application/json");
});
    server.Get("/api/products/1001", [](const httplib::Request& req, httplib::Response& res) {
        res.set_content(
            R"({"product_id":1001,"product_name":"Chicken Breast","status":"safe"})",
            "application/json"
        );
    });

    std::cout << "S.P.R.E.A.D. API running on port 8080..." << std::endl;

    server.listen("0.0.0.0", 8080);

    return 0;
}