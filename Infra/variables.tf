variable "github_runner_token" {
  description = "The registration token for adding a self-hosted runner to a repository or organization."
  type        = string
  sensitive   = true
}
