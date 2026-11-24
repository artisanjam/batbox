# Amazon Bedrock and Google Vertex AI adapters for Anthropic models.
find_package(OpenSSL REQUIRED COMPONENTS Crypto)
add_library(batbox_cloud_providers
  src/services/providers/cloud/Clock.cpp src/services/providers/cloud/Command.cpp src/services/providers/cloud/Crypto.cpp
  src/services/providers/cloud/CloudClients.cpp src/services/providers/cloud/ErrorShape.cpp src/services/providers/cloud/HttpExchange.cpp
  src/services/providers/aws/SigV4.cpp src/services/providers/aws/Credentials.cpp src/services/providers/aws/EventStream.cpp
  src/services/providers/aws/BedrockClient.cpp
  src/services/providers/gcp/GoogleAuth.cpp src/services/providers/gcp/VertexClient.cpp)
target_include_directories(batbox_cloud_providers PUBLIC src)
target_link_libraries(batbox_cloud_providers PUBLIC batbox_transport batbox_core CURL::libcurl OpenSSL::Crypto)
target_compile_options(batbox_cloud_providers PRIVATE -Wall -Wextra -Wpedantic)
