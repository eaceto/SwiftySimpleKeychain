import Danger 
let danger = Danger()

let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
let editedAppFiles = editedFiles.filter {
    $0.fileType == .swift &&
    $0.contains("/Sources/SwiftySimpleKeychain")
}

// Let people bail from the CHANGELOG check
let hasSkipChangelog = danger.github.pullRequest.body?.contains("#no_changelog") ?? false
let hasSkipChangelogLabel = danger.github.issue.labels.first { $0.name == "Skip Changelog" }
let skipCheck = hasSkipChangelog || (hasSkipChangelogLabel != nil)

// Request for a CHANGELOG entry with each app change
if editedAppFiles.count > 0 && !skipCheck {
  fail("Please add a CHANGELOG entry for these changes. If you would like to skip this check, add `#no_changelog` to the PR body and re-run CI.")
}

SwiftLint.lint(configFile: ".swiftlint.yml")
