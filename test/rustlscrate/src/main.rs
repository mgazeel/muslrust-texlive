use hyper::{Body, Client, StatusCode, Uri};

#[tokio::main]
async fn main() {
    let url = ("https://hyper.rs").parse().unwrap();
    let https = hyper_rustls::HttpsConnectorBuilder::new()
        .with_native_roots()
        .https_only()
        .enable_http1()
        .build();

    let client: Client<_, hyper::Body> = Client::builder().build(https);

    let res = client.get(url).await.unwrap();
    assert_eq!(res.status(), StatusCode::OK);
}
