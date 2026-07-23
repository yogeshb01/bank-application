output jenkins-server-public-ip {
  value = aws_instance.jenkins_instance.public_ip
  description = "Public IP of the Jenkins server instance"
}

output jenkins-server-connect-command {
  value = "ssh -i jenkins-server-key.pem ubuntu@${aws_instance.jenkins_instance.public_dns}"
  description = "Connect command for the Jenkins server instance"
}

