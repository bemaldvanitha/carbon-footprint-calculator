Aws.config.update({
                    region: 'eu-west-1',
                    credentials: Aws::Credentials.new(ENV['ACCESS_KEY'], ENV['SECRET_ACCESS_KEY'])
                  })
