// This file needs to be run to connect a Snowflake account to GitHub, in order to import the demo
// This needs to be run as a user with the CREATE INTEGRATION privilege
// Snowflake doc: https://docs.snowflake.com/en/developer-guide/git/git-setting-up#create-an-api-integration-for-interacting-with-the-repository-api

--
set vGitUserName = 'damianrowe';
set vGitAccessToken = --insert GitHub Access Token here;
set vGitAccountURL = 'https://github.com/damianrowe';
set vGitRepo = 'https://github.com/damianrowe/snowflake-demo.git';

-- create database to be used for the Git Integration
CREATE OR REPLACE DATABASE SNOWFLAKE_DEMO_GIT_INTEGRATION;

USE DATABASE SNOWFLAKE_DEMO_GIT_INTEGRATION;

CREATE OR REPLACE SCHEMA secrets;
CREATE OR REPLACE SCHEMA git_repos;

-- secret for connecting to GitHub
CREATE OR REPLACE SECRET secrets.snowflake_demo_secret
TYPE=PASSWORD
USERNAME = $vGitUserName
PASSWORD = $vGitAccessToken;

-- GitHub integration
CREATE OR REPLACE API INTEGRATION snowflake_demo_git_api_integration
    api_provider = git_https_api
    --api_allowed_prefixes = ('https://github.com/damianrowe')
    api_allowed_prefixes = ($vGitAccountURL)
    enabled = true
    allowed_authentication_secrets = (snowflake_demo_secret);

-- Git repo connection
CREATE OR REPLACE GIT REPOSITORY git_repos.snowflake_demo_repo
API_INTEGRATION = snowflake_demo_git_api_integration
GIT_CREDENTIALS = snowflake_demo_secret
ORIGIN = $vGitRepo;

-- fetch repo
ALTER GIT REPOSITORY snowflake_demo_repo FETCH;
