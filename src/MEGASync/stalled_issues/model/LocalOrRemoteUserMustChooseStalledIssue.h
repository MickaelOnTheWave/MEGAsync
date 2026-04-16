#ifndef LOCALORREMOTEUSERMUSTCHOOSESTALLEDISSUE_H
#define LOCALORREMOTEUSERMUSTCHOOSESTALLEDISSUE_H

#include "StalledIssue.h"

class MegaUploader;

class LocalOrRemoteUserMustChooseStalledIssue : public StalledIssue
{
    Q_OBJECT

public:
    LocalOrRemoteUserMustChooseStalledIssue(const mega::MegaSyncStall *stallIssue);
    ~LocalOrRemoteUserMustChooseStalledIssue() = default;

    SolveType autoSolveIssue() override;
    bool isAutoSolvable() const override;
    void setIsSolved(SolveType type) override;
    bool checkForExternalChanges(QObject* context) override;

    HashDiscardRuleOpt hashDiscardRuleForState(SolveType type) const override
    {
        if (type == SolveType::SOLVED)
        {
            return HashDiscardRule{std::chrono::seconds(60)};
        }

        return std::nullopt;
    }

    void fillIssue(const mega::MegaSyncStall *stall) override;
    void endFillingIssue() override;

    bool chooseLocalSide();
    bool chooseRemoteSide();
    bool chooseLastMTimeSide();
    bool chooseBothSides();

    bool UIShowFileAttributes() const override;

    enum class ChosenSide
    {
        NONE = 0,
        REMOTE,
        LOCAL,
        BOTH
    };

    ChosenSide getChosenSide() const;
    ChosenSide lastModifiedSide() const;

    std::shared_ptr<mega::MegaError> getRemoveRemoteError() const;

private:
    ChosenSide mChosenSide = ChosenSide::NONE;
    QString mNewName;
    std::shared_ptr<mega::MegaError> mError;

    QString mLocalCRCAtStart;
    QString mRemoteCRCAtStart;
};

#endif // LOCALORREMOTEUSERMUSTCHOOSESTALLEDISSUE_H
