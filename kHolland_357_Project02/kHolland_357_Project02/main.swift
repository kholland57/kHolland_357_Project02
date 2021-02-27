//
//  main.swift
//  kHolland_357_Project02
//
//  Created by Kelsey Holland on 2/25/21.
//

import Foundation



//------------------------------------------------------------------------------------------
//Main class and function that runs the main menu, calls the password class to perform most of the functions.
class Program
{
    init()
    {
       //Variables initialized here
        var reply = ""
        var keepRunning = true
        var pw = Passwords()
        while keepRunning
        {
            //Main menu user input
            print("Main Menu : \n")
            print("1 : View All Keys \n2 : View Single Password \n3 : Delete Single Password \n4 : Add Single Password")
            reply = Ask.AskQuestion(questionText : "\nPlease Type in a number : ", acceptableReplies:["1","2","3","4"])
            if reply == "1"
            {
                pw.viewAll()
            }
            else if reply == "2"
            {
                pw.viewSingle()
            }
            else if reply == "3"
            {
                pw.deleteSingle()
            }
            else if reply == "4"
            {
                pw.addSingle()
            }
            

            //Runs after a main menu function is called and is completed
            reply = Ask.AskQuestion(questionText : "\n Do you want to keep running the app? ('yes','no'): ", acceptableReplies:["no","yes"])
            if reply == "no"
            {
                keepRunning = false
                break
            }
        }
    }
}
//------------------------------------------------------------------------------

//A class with a function to handle user input for specific replies.
class Ask
{
    static func AskQuestion(questionText output: String, acceptableReplies inputArr: [String], caseSensitive: Bool = false) -> String
    {
        print(output) //ask our wuestion
        
        //handle response
        guard let response = readLine() else {
            //Prints when nothing is typed
            print("Invalid input")
            //recursive function for invalid input
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
        //verify response is acceptable
        if (inputArr.contains(response) || inputArr.isEmpty){
            return response
        }
        else{
            //they didnt type anything at all
            print("Invalid input")
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
            //recursive function for invalid input
        }
    }
}
//--------------------------------


//This runs the main program
let p = Program()


//------------------------------------------------------------------------------------------
//This class handles encryption/decryption
class ceasarSypher
{
    //this function calls the necessary functions for encryption and returns a string
    func encrypt(stringToEncrypt: String) -> String
    {
        var newString = stringToEncrypt
        newString = stringShift(input: newString)
        newString = reverseInput(input: newString)
        return newString
    }
    
    //Same thing as encryption function but runs functions to decrypt, returns a string
    func decrypt(stringToDecrypt: String) -> String
    {
        var newString = stringToDecrypt
        newString = reverseInput(input: newString)
        newString = stringShiftReverse(input: newString)
        return newString
    }
    
    //This function reverses a string and returns it
    func reverseInput(input: String) -> String
    {
        return String(input.reversed())
    }
    
    //This is the start of ceasar sypher
    func stringShift(input: String) -> String
    {
        let str = input
        var strShift = ""
        let shift: Int = str.count

        for letter in str {
            strShift += String(translate( l: letter, trans: shift))
        }
        return strShift
    }
    
    //This function is called to reverse ceasar sypher
    func stringShiftReverse(input: String) -> String
    {
        let str = input
        var strShift = ""
        
        let shift: Int = str.count
      
        for letter in str {
            strShift += String(translateReverse( l: letter, trans: shift))
            
        }
        return strShift
    }
    
    
    //This function encrypts a character, and returns a character
    func translate(l: Character, trans: Int) ->Character
    {
        if let ascii = l.asciiValue
        {
            var outputInt = ascii
            if ascii >= 97 && ascii <= 122
            {
                //example equation:
                // a = 97
                // 97 - 97 = 0
                // 0 + 27 = 27
                // 27 % 26 = 1
                // 1 + 97 = 98
                // 98 = b
                
                
                outputInt = ((ascii-97+UInt8(trans))%26)+97
            }
            
            else if (ascii >= 65 && ascii <= 90)
            {
                outputInt = ((ascii-65+UInt8(trans))%26)+65
            }
            
            return Character(UnicodeScalar(outputInt))
        }
        return Character("")
    }
    
    
    //This function does the same as the previous but reverses it by changing trans to a negative integer variable, transrev
    //since modulo in swift cannot handle negatives, two new variables had to be made and another function had to be called
    //The integer calculated is then casted back to a Uint8
    
    func translateReverse(l: Character, trans: Int) ->Character
    {
        if let ascii = l.asciiValue
        {
            let outputIntA = ascii
            var outputInt = Int(outputIntA)
            if ascii >= 97 && ascii <= 122
            {
                
                let transRev : Int = trans * -1
                let newAscii : Int  = Int(ascii)
                
                let moda : Int  = Int(newAscii-97+(transRev))
                let modb = Int(26)
                
                
                outputInt = Int(mod(inputa: moda, inputb: modb))+97
               //This is here so the program doesn't crash
                if (outputInt < 0)
                {
                    //print("NEGATIVE NUMBER")
                    outputInt = outputInt + 128
                    
                }
            }
            
            else if (ascii >= 65 && ascii <= 90)
            {
        
                let transRev = Int(trans * -1)
                let newAscii  = Int(ascii)
               
            
                let moda : Int = Int(newAscii-65+(transRev))
                let modb = Int(26)
                
                
                outputInt = Int(mod(inputa: moda, inputb: modb))+65
                
                if (outputInt < 0)
                {
                   // print("NEGATIVE NUMBER")
                    outputInt = outputInt + 128
                }
            }
            
            let outputIntUnsigned = UInt8(outputInt)
            return Character(UnicodeScalar(outputIntUnsigned))
        }
        
        print("NOTHING" )
        return Character("")
    }
    
    //This is a modulo function that can handle negative numbers
    //This function is from this stack overflow page : https://stackoverflow.com/questions/41180292/negative-number-modulo-in-swift#:~:text=The%20remainder%20operator%20(%20%25%20)%20is,rather%20than%20a%20modulo%20operation.&text=giving%20a%20remainder%20value%20of%20%2D1%20.
    func mod(inputa : Int, inputb : Int) -> Int {
        precondition( inputb > 0, "Enter a positive number please")
        let r = inputa % inputb
        return r >= 0 ? r : r + inputb
     
    }
}



//------------------------------------------------------------------------------------------

//This class handles JSON file input and output
class JsonIO
{

    //This function creates a file if there isn't one, and updates it with the new dictionary parameter if there is one
    func writeFile(inputDict : Dictionary<String,String> )
    {
        print("GOT HERE TO WRITE")
        var dictionary = inputDict
        
        //create file and write JSON
        do {
            let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("mybadpasswords.json")

            try JSONSerialization.data(withJSONObject: dictionary).write(to: fileURL)
        } catch {
            print(error)
        }
    }


    
    //This function reads in a file "mybadpasswords.json" from the support directory
    func readFile() -> Dictionary<String,String>
    {
        //read JSON
        var dictionary: [String:String] = [:]
        do {
            let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("mybadpasswords.json")

            let data = try Data(contentsOf: fileURL)
            dictionary  = try JSONSerialization.jsonObject(with: data) as! [String : String]
            
        } catch {
            print("Error, No current file in location, new dictionary will be created")
            let dictDefault: [String:String] = [:]
            return dictDefault
        }
        return dictionary
    }


    //Guard Statement from what we learned in class:
    func unwrapWithGuard(input:String?)-> String
    {
        guard let unwrappedString = input else {
            print("bollocks")
            return "ERROR"
        }
        print("Sucess: \(unwrappedString)")
        return unwrappedString
    }
    
}



//------------------------------------------------------------------------------------------

//This class handles most of the password creation, deletion, and dictionary things
class Passwords
{
    //variables and classes declared here
    var fileIO = JsonIO()
    var secure = ceasarSypher()
    var dictionary: [String:String] = [:]
    var dictKeys: [String] = []
    

    //This runs when the class is first called, the program tries to read in from a json file if there is one to create the dictionary
    init(){
        print("Password Class Initialized.")
        self.dictionary = fileIO.readFile()
        for key in dictionary.keys{
            dictKeys.append(key)
        }
    }
  
   //There two functions read in and write out
    func writeOut()
    {
        print("Writing dictionary out to file")
        fileIO.writeFile(inputDict: dictionary)
    }
    func readIn() -> Dictionary<String, String>
    {
        print("Reading in dictionary file")
        return fileIO.readFile()
    }
        
    
    //This function lists all of the keys in the dictionary
    func viewAll() {
        print("These are the current keys:")
        for key in dictionary.keys{
            
            print(key)
        }
    }
    
    //This lets the user view a single password if they enter a key, and the right passphrase
    //The password is decrypted, then the passphrase is removed
    //If the passphrases do not match, it will return to the main menu
    func viewSingle( ) {
        print ("Enter a key:")
        let userKey = unwrapWithGuard(input: readLine())
        
        
        if (dictKeys.contains(userKey)){
            //Asks for passphrase
            var answer : String = unwrapWithGuard(input : dictionary[userKey])
            //Decryption here:
            answer = secure.decrypt(stringToDecrypt: answer)
            
            print("Enter the passphrase : ")
            let passPhraseCheck : String = unwrapWithGuard(input: readLine())
            if answer.contains(passPhraseCheck) && (answer.count > 2)
            {
                answer = answer.replacingOccurrences(of: passPhraseCheck, with: "")
                print("Password : \(answer)")
            }
            else
            {
                print("Error : Passphrases do not match, returning to main menu.")
            }
        }
        else{
        
            print("Error : Dictionary does not contain key.")
            print("Returning to main menu.")
        }
    }
    
    //This function lets the user add a single key:value pair to the dictionary
    //Passphrases must be longer than 2 characters, because if it was only one character than it would
    //not be secure and the program will have a very high chance of showing the password to the wrong user later
    //If a pass
    func addSingle()
    {
        
        print ("What name do you want to store it under?:")
        let keyName = unwrapWithGuard(input: readLine())
        
        
        print ("Enter the password:")
        var newPassword = unwrapWithGuard(input: readLine())
        
        
        print ("Enter your passphrase: (Must be at least 3 characters, and must be different from and not within your passwords)")
        let passPhrase = unwrapWithGuard(input: readLine())
        if (passPhrase.count > 2 && passPhrase != newPassword && !newPassword.contains(passPhrase))
        {
            
            dictKeys.append(keyName)
            newPassword = newPassword + passPhrase
            newPassword = secure.encrypt(stringToEncrypt: newPassword)
            self.dictionary.updateValue(newPassword, forKey: keyName)
            fileIO.writeFile(inputDict: dictionary)
        }
        else {
            print("Passphrase does not meet qualifications so password will not be stored, returning to main menu.")
        }
    }
    
    //This deletes the password and changes it to nil based on the key
    //This does not delete the key though
    func deleteSingle() {
        
        print ("Enter a key:")
        let userKey = unwrapWithGuard(input: readLine())
        
        
        if (dictKeys.contains(userKey)){
          
           print("Now Deleting password.")
            dictionary[userKey] = nil
            fileIO.writeFile(inputDict: self.dictionary)
        }
        else{
            //The key doesnt exist
            print("Dictionary does not contain key.")
            print("Returning to main menu.")
        }
    }
    
    //unwrap with guard function from class
    func unwrapWithGuard(input:String?)-> String
    {
        guard let unwrappedString = input else {
            print("Error Unwrapping input string")
            return "ERROR"
        }
        return unwrappedString
    }
}

//------------------------------------------------------------------------------------------
