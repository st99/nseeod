message('library paths:\n', paste('... ', .libPaths(), sep='', collapse='\n'))

chrome.sys = 'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe'

chrome.portable = file.path(getwd(),
                            'GoogleChromePortable/App/Chrome-bin/chrome.exe')

launch.browser = function(appUrl, browser.path=chrome.sys) {
    message('Browser path: ', browser.path)
    shell(sprintf('"%s" --app=%s', browser.path, appUrl))
}

shiny::runApp('./shiny/', launch.browser=launch.browser)