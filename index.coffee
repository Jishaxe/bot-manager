fs = require 'fs'
forever = require 'forever-monitor'

# Thanks http://stackoverflow.com/questions/18112204/get-all-directories-within-directory-nodejs for letting me be lazy
# List dirs in this area
getDirs = (rootDir) ->
    files = fs.readdirSync(rootDir)
    dirs = []

    for file in files
        if file[0] != '.'
            filePath = "#{rootDir}/#{file}"
            stat = fs.statSync(filePath)

            if stat.isDirectory()
                dirs.push(file)

    return dirs

bots = []

# Find bots here
for dir in getDirs './'
  # A subdirectory is a bot if it has a .git and a package.json
  if (fs.existsSync "#{dir}/.git") and (fs.existsSync "#{dir}/package.json")
    console.log "Starting bot #{dir}"

    # Use forever to call npm start in the bot directory and retry restarting 5 times before failing
    bot = new (forever.Monitor)(["npm", "start"], {
      max: 5
      cwd: dir
      spawnWith: {shell: true}
    })

    bot.on "error", (error) ->
      "#{packageJson.name} has had an error: #{error}"

    bot.on "exit", ->
      "#{packageJson.name} HAS CRASHED 5 TIMES IN A ROW. WILL NOT ATTEMPT START AGAIN"

    bot.start()
