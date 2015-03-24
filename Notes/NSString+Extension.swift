//  NSString+Extension.swift


import UIKit

extension NSString
{
    //- (NSString *)documentsDirectoryPath
    //    {
    //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //        NSString *documentsDirectory = [paths objectAtIndex:0];
    //        return documentsDirectory;
    //}
    func documentsDirectoryPath() -> NSString
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        return documentsDirectory
        
    }
    
//    - (NSString *)cacheDirectoryPath
//    {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    return documentsDirectory;
//    }
    
    func cacheDirectoryPath() -> NSString
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as NSString
        
        return documentsDirectory
    }

//    - (NSString *)privateDirectoryPath
//    {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
//    
//    NSError *error;
//    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
//    
//    return documentsDirectory;
//    
//    }

    func privateDirectoryPath() ->NSString
    {
        var documentsDirectory = NSSearchPathForDirectoriesInDomains(.LibraryDirectory , .UserDomainMask, true)[0] as NSString
        
        documentsDirectory = documentsDirectory.stringByAppendingPathComponent("Private Documents")
        
         var error: NSError? = nil
        NSFileManager.defaultManager().createDirectoryAtPath(documentsDirectory, withIntermediateDirectories: true, attributes: nil, error: &error)
        return documentsDirectory
    }
    
//    - (NSString *)pathInDocumentDirectory
//    {
//    NSString *documentsDirectory = [self documentsDirectoryPath];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
//    
//    return path;
//    }

    func pathInDocumentDirectory() -> NSString
    {
        let documentsDirectory = self .documentsDirectoryPath()
        let path = documentsDirectory.stringByAppendingPathComponent(self)
        
        return path
    }
    
//    - (NSString *)pathInCacheDirectory
//    {
//    NSString *documentsDirectory = [self cacheDirectoryPath];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
//    
//    return path;
//    }

    func pathInCacheDirectory() -> NSString
    {
        let documentsDirectory = self.cacheDirectoryPath()
        let path = documentsDirectory.stringByAppendingPathComponent(self)
        return path
    }
    
    
//    - (NSString *)pathInPrivateDirectory
//    {
//    NSString *documentsDirectory = [self privateDirectoryPath];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
//    
//    return path;
//    }

    func pathInPrivateDirectory() ->NSString
    {
        let documentsDirectory = self.privateDirectoryPath()
        let path = documentsDirectory.stringByAppendingPathComponent(self)
        return path
    }
    
//    - (NSString *)pathInDirectory:(NSString *)dir cachedData:(BOOL)yesOrNo
//    {
//    NSString *documentsDirectory = nil;
//    if (yesOrNo) {
//    documentsDirectory = [self cacheDirectoryPath];
//    }
//    else {
//    documentsDirectory = [self documentsDirectoryPath];
//    }
//    NSString *dirPath = [documentsDirectory stringByAppendingString:dir];
//    NSString *path = [dirPath stringByAppendingString:self];
//    
//    NSFileManager *manager = [NSFileManager defaultManager];
//    [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    return path;
//    }
    
    func pathInDirectory(dir:NSString, cachedData:Bool ) -> NSString
    {
        var documentsDirectory : NSString
        if cachedData
        {
            documentsDirectory = self.cacheDirectoryPath()
        }
        else
        {
            documentsDirectory = self.documentsDirectoryPath()
        }
        var dirPath = documentsDirectory.stringByAppendingString(dir)
        let path = dirPath.stringByAppendingString(self)
        var manager = NSFileManager.defaultManager()
        manager.createDirectoryAtPath(dirPath, withIntermediateDirectories: true, attributes: nil, error: nil)
        return path
    }

    
//    - (NSString *)pathInDirectory:(NSString *)dir
//    {
//    return [self pathInDirectory:dir cachedData:YES];
//    }

    
    func pathInDirectory(dir:NSString) -> NSString
    {
        return self.pathInDirectory(dir, cachedData: true)
    }
    
//    - (NSString *)removeWhiteSpace
//    {
//    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    }


    func removeWhiteSpace() ->NSString
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }

    
    
    
//    - (NSString *)stringByNormalizingCharacterInSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement
//    {
//    NSMutableString* result = [NSMutableString string];
//    NSScanner* scanner = [NSScanner scannerWithString:self];
//    while (![scanner isAtEnd]) {
//    if ([scanner scanCharactersFromSet:characterSet intoString:NULL]) {
//    [result appendString:replacement];
//    }
//    NSString* stringPart = nil;
//    if ([scanner scanUpToCharactersFromSet:characterSet intoString:&stringPart]) {
//    [result appendString:stringPart];
//    }
//    }
//    
//    return [[result copy] autorelease];
//    }

    
    func stringByNormalizingCharacterInSet(characterSet:NSCharacterSet, replacementWithString :NSString)
    {
        var result: NSMutableString = NSMutableString()
        var scanner: NSScanner = NSScanner.localizedScannerWithString(self) as NSScanner
        
        while !scanner.atEnd
        {
            var isCharacterSet:Bool = scanner.scanCharactersFromSet(characterSet, intoString:AutoreleasingUnsafeMutablePointer()) as Bool
            if isCharacterSet
            {
                result.appendString(replacementWithString)
            }
            var stringPart:NSString = NSString()
            if scanner.scanCharactersFromSet(characterSet, intoString: AutoreleasingUnsafeMutablePointer(&stringPart))
            {
                result.appendString(stringPart)
            }
        }
        return copy(result)
    }

//    - (NSString *)bindSQLCharacters
//    {
//    NSString *bindString = self;
//    
//    bindString = [bindString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
//    
//    return bindString;
//    }


    func bindSQLCharacters() -> NSString
    {
        var bindString = self as NSString
        bindString = bindString.stringByReplacingOccurrencesOfString("'", withString: "''")
        return bindString
    }

    
//    - (NSString *)trimSpaces
//    {
//    return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n "]];
//    }

    func trimSpaces()->NSString
    {
        
        return self.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\t\n "))
    }

//    - (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
//    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]];
//    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
//    return @"";
//    }
//    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
//    }


    func stringByTrimmingLeadingCharactersInSet(characterSet:NSCharacterSet)->NSString
    {
        let rangeOfFirstWantedCharacter:NSRange = self.rangeOfCharacterFromSet(characterSet.invertedSet)
        
        if rangeOfFirstWantedCharacter.location == NSNotFound
        {
            return ""
        }
        return self.substringFromIndex(rangeOfFirstWantedCharacter.location)
    }
    

//    - (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters {
//    return [self stringByTrimmingLeadingCharactersInSet:
//    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    }

    
    func stringByTrimmingLeadingWhitespaceAndNewlineCharacters() -> NSString
    {
        return self.stringByTrimmingLeadingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
//    - (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
//    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
//    options:NSBackwardsSearch];
//    if (rangeOfLastWantedCharacter.location == NSNotFound) {
//    return @"";
//    }
//    return [self substringToIndex:rangeOfLastWantedCharacter.location+1]; // non-inclusive
//    }

    
    func stringByTrimmingTrailingCharactersInSet(characterSet:NSCharacterSet) -> NSString
    {
        let rangeOfLastWantedCharacter = self.rangeOfCharacterFromSet(characterSet.invertedSet, options: NSStringCompareOptions.BackwardsSearch)
        if rangeOfLastWantedCharacter.location == NSNotFound
        {
            return ""
        }
        return self.substringToIndex(rangeOfLastWantedCharacter.location+1) // non-inclusive
    }


//    - (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters {
//    return [self stringByTrimmingTrailingCharactersInSet:
//    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    }

    
    func stringByTrimmingTrailingWhitespaceAndNewlineCharacters() -> NSString
    {
        return self.stringByTrimmingTrailingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    
    
//    + (BOOL)validateEmail:(NSString *)candidate
//    {
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    
//    return [emailTest evaluateWithObject:candidate];
//    }

    
    func validateEmail(candidate:NSString)->Bool
    {
        let emailRegex:NSString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        var emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES \(emailRegex)")!
        return emailTest.evaluateWithObject(candidate)
    }
    
    
//    // Range must be in {a,b}. Where a is mimimum length and b is max length
//    + (BOOL)validateForNumericAndCharacets:(NSString *)candidate WithLengthRange:(NSString *)strRange
//    {
//    BOOL valid = NO;
//    NSCharacterSet *alphaNums = [NSCharacterSet alphanumericCharacterSet];
//    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:candidate];
//    BOOL isAlphaNumeric = [alphaNums isSupersetOfSet:inStringSet];
//    if(isAlphaNumeric){
//    NSString *emailRegex = [NSString stringWithFormat:@"[%@]%@",candidate, strRange];
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    valid =[emailTest evaluateWithObject:candidate];
//    }
//    return valid;
//    }

    
    func validateForNumericAndCharacets(candidate:NSString, strRange:NSString)->Bool
    {
        var valid: Bool = false
        var alphaNums:NSCharacterSet = NSCharacterSet.alphanumericCharacterSet()
        var inStringSet: NSCharacterSet = NSCharacterSet(charactersInString:candidate)
        var isAlphaNumeric = alphaNums.isSupersetOfSet(inStringSet)
        
        if isAlphaNumeric
        {
            let emailRegex:NSString = NSString(string: "[\(candidate)]\(strRange)")
            let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES\(emailRegex)")!
            valid = emailTest.evaluateWithObject(candidate)
        }
        return valid
    }
    
    
//    + (BOOL)validatPhoneNumber:(NSString*) phonenum
//    {
//      if (phonenum.length!=14)
//      {
//          return NO;
//      }
//      return YES;
//    }

    
    func validatPhoneNumber(phonenum:NSString)->Bool
    {
        if phonenum.length != 14
        {
            return false
        }
        return true
    }
    
//    //+99-9999999999
//    + (BOOL) validatePhone: (NSString *) candidate {
//    NSString *phoneRegex = @"^([+]{1})([0-9]{2,6})([-]{1})([0-9]{10})$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    
//    return [phoneTest evaluateWithObject:candidate];
//    }

    
    func validatePhone(candidate:NSString)->Bool
    {
        let phoneRegex:NSString = "^([+]{1})([0-9]{2,6})([-]{1})([0-9]{10})$"
        let phoneTest:NSPredicate = NSPredicate(format: "SELF MATCHES \(phoneRegex)")!
        return phoneTest.evaluateWithObject(candidate)
    }
}

