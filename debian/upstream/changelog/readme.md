curl https://puppet.com/docs/mcollective/current/changelog.html > /tmp/changelog.html
pandoc -f html -t markdown /tmp/changelog.html > /tmp/changelog.md
