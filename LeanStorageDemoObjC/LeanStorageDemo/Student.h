

static NSString *const kStudentKeyHobbies = @"hobbies";
static NSString *const kStudnetKeyAvatar = @"avatar";
static NSString *const kStudnetKeyAge = @"age";
static NSString *const kStudnetKeyGender = @"gender";
static NSString *const kStudentKeyAny = @"any";
static NSString *const kStudentKeyName = @"name";
static NSString *const kStudnetKeyFriends = @"friends";

typedef enum{
    GenderUnkonwn = 0,
    GenderMale = 1,
    GenderFamale
}GenderType;

@interface Student : LCObject<LCSubclassing>

@property (nonatomic, strong) LCFile *avatar;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) GenderType gender;
@property (nonatomic, strong) NSArray *hobbies;
@property (nonatomic, strong) id any;

@end
