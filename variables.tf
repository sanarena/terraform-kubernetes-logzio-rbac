variable "logzio_listener" {
  description = "Logz.io listener endpoint (for example: listener.logz.io)"
  default = "listener.logz.io"
  type = string
}

variable "logzio_token" {
  description = "Logz.io token to send logs into"
  type = string
}