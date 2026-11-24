#pragma once
#include "core/api_errors/ApiErrors.hpp"
#include "lib/http/Retry.hpp"
#include <exception>
namespace batbox::transport {
retry::ErrorRecord errorRecordFromException(std::exception_ptr failure);
api_errors::Failure apiFailureFromException(std::exception_ptr failure);
} // namespace batbox::transport
