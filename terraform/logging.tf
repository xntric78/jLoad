resource "aws_cloudwatch_log_group" "results" {
  name = "jmeter-results"
}

resource "aws_cloudwatch_log_metric_filter" "requests" {
  name           = "Requests"
  pattern        = ""
  log_group_name = "${aws_cloudwatch_log_group.results.name}"

  metric_transformation {
    name      = "AllRequests"
    namespace = "YourNamespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http200" {
  name           = "http200"
  pattern        = "[timeStamp,elapsed,label,responseCode=2*,bytes,sentBytes,grpThreads,allThreads,URL,Latency,Hostname,IdleTime,Connect]"
  log_group_name = "${aws_cloudwatch_log_group.results.name}"

  metric_transformation {
    name      = "AllHTTP_200"
    namespace = "YourNamespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http400" {
  name           = "http400"
  pattern        = "[timeStamp,elapsed,label,responseCode=4*,bytes,sentBytes,grpThreads,allThreads,URL,Latency,Hostname,IdleTime,Connect]"
  log_group_name = "${aws_cloudwatch_log_group.results.name}"

  metric_transformation {
    name      = "AllHTTP_400"
    namespace = "YourNamespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http500" {
  name           = "http500"
  pattern        = "[timeStamp,elapsed,label,responseCode=5*,bytes,sentBytes,grpThreads,allThreads,URL,Latency,Hostname,IdleTime,Connect]"
  log_group_name = "${aws_cloudwatch_log_group.results.name}"

  metric_transformation {
    name      = "AllHTTP_500"
    namespace = "YourNamespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ResponseTimeMs" {
  name           = "ResponseTimeMs"
  pattern        = "[timeStamp,elapsed,label,responseCode,bytes,sentBytes,grpThreads,allThreads,URL,Latency,Hostname,IdleTime,Connect]"
  log_group_name = "${aws_cloudwatch_log_group.results.name}"

  metric_transformation {
    name      = "AllResponseTime_ms"
    namespace = "YourNamespace"
    value     = "$elapsed"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ConnectTimeMs" {
  name           = "ConnectTimeMs"
  pattern        = "[timeStamp,elapsed,label,responseCode,bytes,sentBytes,grpThreads,allThreads,URL,Latency,Hostname,IdleTime,Connect]"
  log_group_name = "${aws_cloudwatch_log_group.results.name}"

  metric_transformation {
    name      = "AllConnectTime_ms"
    namespace = "YourNamespace"
    value     = "$Connect"
  }
}

resource "aws_cloudwatch_log_metric_filter" "LatencyMs" {
  name           = "LatencyMs"
  pattern        = "[timeStamp,elapsed,label,responseCode,bytes,sentBytes,grpThreads,allThreads,URL,Latency,Hostname,IdleTime,Connect]"
  log_group_name = "${aws_cloudwatch_log_group.results.name}"

  metric_transformation {
    name      = "AllLatency_ms"
    namespace = "YourNamespace"
    value     = "$Latency"
  }
}

resource "aws_cloudwatch_log_metric_filter" "SentBytes" {
  name           = "SentBytes"
  pattern        = "[timeStamp,elapsed,label,responseCode,bytes,sentBytes,grpThreads,allThreads,URL,Latency,Hostname,IdleTime,Connect]"
  log_group_name = "${aws_cloudwatch_log_group.results.name}"

  metric_transformation {
    name      = "AllSentBytes"
    namespace = "YourNamespace"
    value     = "$sentBytes"
  }
}

resource "aws_cloudwatch_log_metric_filter" "ReceivedBytes" {
  name           = "ReceivedBytes"
  pattern        = "[timeStamp,elapsed,label,responseCode,bytes,sentBytes,grpThreads,allThreads,URL,Latency,Hostname,IdleTime,Connect]"
  log_group_name = "${aws_cloudwatch_log_group.results.name}"

  metric_transformation {
    name      = "AllReceivedBytes"
    namespace = "YourNamespace"
    value     = "$bytes"
  }
}
