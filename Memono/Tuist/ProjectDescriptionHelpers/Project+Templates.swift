//
//  Project+Templates.swift
//  Config
//
//  Created by 조호근 on 8/1/25.
//

import ProjectDescription

public extension Project {
    
    /// 공통 설정이 적용된 Tuist Project를 생성합니다.
    ///
    /// - Parameters:
    ///   - name: 모듈 또는 프로젝트 이름입니다.
    ///   - bundleId: 번들 식별자 (예: `io.tuist.Memono`)
    ///   - product: 생성할 제품 타입입니다. (.app, .staticFramework 등)
    ///   - dependencies: 의존성 타겟 목록입니다. 기본값은 빈 배열입니다.
    ///   - hasTestTarget: 테스트 타겟 포함 여부입니다. 기본값은 true입니다.
    ///
    /// - Returns: 공통 설정이 적용된 Tuist용 `Project` 객체를 반환합니다.
    static func make(
        name: String,
        bundleId: String,
        product: Product,
        dependencies: [TargetDependency] = [],
        hasTestTarget: Bool = true
    ) -> Project {
        var targets: [Target] = []
        
        let mainTarget = Target.target(
            name: name,
            destinations: .iOS,
            product: product,
            bundleId: bundleId,
            deploymentTargets: .iOS("16.0"),
            infoPlist: product == .app ? appInfoPlist() : .default,
            sources: ["Memono/Sources/**"],
            resources: product == .app ? ["Memono/Resources/**"] : [],
            dependencies: dependencies
        )
        targets.append(mainTarget)
        
        if hasTestTarget {
            let testTarget = Target.target(
                name: "\(name)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: "\(bundleId)Tests",
                infoPlist: .default,
                sources: ["Memono/Tests/**"],
                resources: [],
                dependencies: [.target(name: name)]
            )
            targets.append(testTarget)
        }
        
        return Project(
            name: name,
            options: .options(
                defaultKnownRegions: ["en", "ko"],
                developmentRegion: "ko"
            ),
            settings: appSettings(),
            targets: targets
        )
    }
    
    static func appSettings() -> Settings {
        .settings(
            base: [
                "CODE_SIGN_STYLE": "Automatic",
                "DEVELOPMENT_TEAM": "MVHA5LVM49"
            ]
        )
    }
    
    static func appInfoPlist() -> InfoPlist {
        .extendingDefault(
            with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": ""
                ]
            ]
        )
    }
}
