# Log Parser
The project consist in implementation for parse log the Game Quake

## Overview
This application is designed to analyze Quake game log files and extract useful information from them.

## Features
- Upload your Quake log file.
- Extract various information such as number of matches, total players, cause of deaths and player scores.
- Display parsed data in a structured format (JSON).

## Some Game Rules
- When `<world>` kill a player, that player loses -1 kill score.
- Since `<world>` is not a player, it should not appear in the list of players or in the dictionary of kills.
- The counter `total_kills` includes player and world deaths.
- When committing suicide the player loses -1 kill score.

## Requirements
- Ruby 3.2.3
- Rspec - Lasted version

## Running the application

You can run the application in two ways.

### Via Docker:

1. Ensure you have Docker installed on your machine. If not, you can download and install Docker from https://www.docker.com/.

2. Clone the repository to your local environment:

   ```bash
   git clone https://github.com/lhonrio/log-parser.git
   ```

3. Build the Docker image:

   ```bash
   cd log-parser
   docker build -t log-parser .
   ```

4. Run the Docker container:

   ```bash
   docker run -it --rm log-parser
   ```

5. Test via the terminal or your preferred testing application:

    example request: 
    ```bash
   curl --location 'http://127.0.0.1:3000/logs/analyze' \
    --form 'file=@"your_log_file.log"'
   ```
   example response:
   ```json
   {
    "game_1": {
        "total_kills":0,
        "players":[],
        "kills":{},
        "kills_by_means":{}
        }
    },
    {...}
   ```
 

### Manually:

1. Clone the repository:

   ```bash
   git clone https://github.com/lhonrio/log-parser.git
   ```

2. Navigate to the project directory:

   ```bash
   cd log-parser
   ```

3. Install dependencies:

   ```ruby
   bundle install
   ```

4. Execute application:

    ```ruby
   rails s
   ```

5. Test via the terminal or your preferred testing application:

    example request: 
    ```bash
   curl --location 'http://127.0.0.1:3000/logs/analyze' \
    --form 'file=@"your_log_file.log"'
   ```
   example response:
   ```json
   {
    "game_1": {
        "total_kills":0,
        "players":[],
        "kills":{},
        "kills_by_means":{}
        }
    },
    {...}
   ```

## Units Test

The project contains some unit tests, to run them follow these steps:

1. Navigate to the project directory:

   ```bash
   cd log-parser
   ```

2. Execute the command line:

   ```bash
   rspec
   ```

3. The result should similar to example:

   ```bash
   Finished in 0.04021 seconds (files took 0.27536 seconds to load)
   12 examples, 0 failures
   ```

## Contact

If you have any questions about the project, feel free to reach out:

- Email: lhonrio@gmail.com
- Linkedln: https://www.linkedin.com/in/lhonrio/