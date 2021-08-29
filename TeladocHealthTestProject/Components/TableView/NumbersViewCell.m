//
//  NumbersViewCell.m
//  TeladocHealthTestProject
//
//  Created by Ivan Shepler on 30/08/2021.
//

#import "NumbersViewCell.h"

@implementation NumbersViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected == YES) {
        self.contentView.backgroundColor = UIColor.systemBlueColor;
    } else {
        self.contentView.backgroundColor = UIColor.systemBackgroundColor;
    }
}

- (void)configureUI {
    self.contentView.backgroundColor = UIColor.systemBackgroundColor;
    [self.contentView addSubview:[self numberImageView]];
    [self.contentView addSubview:[self numberLabel]];
    _numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _numberImageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *constraints = @[
        [_numberLabel.centerYAnchor constraintEqualToAnchor: self.contentView.centerYAnchor],
        [_numberLabel.leftAnchor constraintEqualToAnchor: self.contentView.leftAnchor constant: 15],
        [_numberLabel.rightAnchor constraintLessThanOrEqualToAnchor: _numberImageView.leftAnchor],
        [_numberImageView.rightAnchor constraintEqualToAnchor: self.contentView.rightAnchor constant: -15],
        [_numberImageView.centerYAnchor constraintEqualToAnchor: self.contentView.centerYAnchor],
    ];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _numberLabel.text = NULL;
    _numberImageView.image = NULL;
}

- (UIImageView *)numberImageView {
    if (_numberImageView == NULL) {
        _numberImageView = [[UIImageView alloc] init];
        _numberImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _numberImageView;
}

- (UILabel *)numberLabel {
    if (_numberLabel == NULL) {
        _numberLabel = [[UILabel alloc] init];
    }
    
    return _numberLabel;
}

@end
