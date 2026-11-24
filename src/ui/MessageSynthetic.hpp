#pragma once

#include "ui/MessageDecisions.hpp"
#include "ui/StreamReducer.hpp"
#include "core/messages/Messages.hpp"

namespace batbox::interactive {

MessageRefs syntheticStreamingGadgetUseMessages(
    const std::vector<StreamingGadgetUse>& streamingGadgetUses,
    const GadgetIDs& inProgressGadgetUseIDs,
    const MessageRefs& normalizedMessages,
    messages::Services& messageServices);

} // namespace batbox::interactive
