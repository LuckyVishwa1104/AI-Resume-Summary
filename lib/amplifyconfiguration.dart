const amplifyconfig = ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {
          "Default": {}
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "<PoolId>",
            "AppClientId": "<AppClientId>",
            "Region": "ap-south-1"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH",
          }
        }
      }
    }
  }
}''';
