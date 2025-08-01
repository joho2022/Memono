import ProjectDescription
import ProjectDescriptionHelpers

let app = Project.make(
    name: "Memono",
    bundleId: "io.tuist.Memono",
    product: .app,
    dependencies: [
        .external(name: "ComposableArchitecture", condition: .none)
    ]
)
