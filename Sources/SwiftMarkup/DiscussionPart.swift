/// A part of the discussion (either text or a callout).
public protocol DiscussionPart {}
extension String: DiscussionPart {}
extension Callout: DiscussionPart {}
