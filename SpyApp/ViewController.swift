import UIKit

protocol CipherProtocol {
    func encrypt(plaintext: String, secret: String) -> String
}

struct CesarCipher: CipherProtocol {
    func encrypt(plaintext: String, secret: String) -> String {
        guard let secretInt = UInt32(secret) else {
            return "Error"
        }
        var encoded = ""
        for character in plaintext {
            guard let firstUnicodeScalar = character.unicodeScalars.first else {
                continue
            }
            let unicode = firstUnicodeScalar.value
            let shiftedUnicode = unicode + secretInt
            let shiftedCharacter = String(UnicodeScalar(UInt8(shiftedUnicode)))

            encoded += shiftedCharacter
        }
        return encoded
    }
}

struct AlphanumbericCesarCipher: CipherProtocol {
    func encrypt(plaintext: String, secret: String) -> String {
        guard let secretInt = UInt32(secret) else {
            return "Error"
        }
        var encoded = ""
        let newplaintext = plaintext.uppercased()
        for character in newplaintext {
            let unicode = character.unicodeScalars.first!.value
            if (unicode < 48 || unicode > 122 || (unicode > 57 && unicode < 65) || (unicode > 90 && unicode < 97)) {
                return "input contains invalid characters"
            }
            var shiftedUnicode = unicode + secretInt
            if secretInt > 0 && shiftedUnicode > 90 {
                shiftedUnicode = shiftedUnicode - 43
            }else if secretInt > 0 && shiftedUnicode > 57 && shiftedUnicode < 65{
                shiftedUnicode = shiftedUnicode + 7
            }else if secretInt < 0 && shiftedUnicode < 48 {
                shiftedUnicode = shiftedUnicode + 43
            }else if secretInt < 0 && shiftedUnicode > 57 && shiftedUnicode < 65{
                shiftedUnicode = shiftedUnicode - 7
            }
            let shiftedCharacter = String(UnicodeScalar(UInt8(shiftedUnicode)))
            encoded = encoded + shiftedCharacter
        }
        return encoded
    }
}

struct ROT_13_Cipher: CipherProtocol {
    func encrypt(plaintext: String, secret: String) -> String {
        var encoded = ""
        for character in plaintext {
            let unicode = character.unicodeScalars.first!.value
            var shiftedUnicode = unicode + 13
            if shiftedUnicode > 126 {
                shiftedUnicode = shiftedUnicode - 79
            }
            let shiftedCharacter = String(UnicodeScalar(UInt8(shiftedUnicode)))
            encoded = encoded + shiftedCharacter
        }
        return encoded
    }
}
    
struct ROT_5_Cipher: CipherProtocol {
    func encrypt(plaintext: String, secret: String) -> String {
        var encoded = ""
        for character in plaintext {
            let unicode = character.unicodeScalars.first!.value
            if unicode == 32 {
                return "input string cannot have space"
            }else if unicode < 48{
                return "input has invalid characters"
            }
            var shiftedUnicode = unicode - 5
            if shiftedUnicode < 48{
                shiftedUnicode = shiftedUnicode + 79
            }
            let shiftedCharacter = String(UnicodeScalar(UInt8(shiftedUnicode)))
            encoded = encoded + shiftedCharacter
        }
        return encoded
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var secretField: UITextField!
    @IBOutlet weak var output: UILabel!

    var cipher: CipherProtocol = CesarCipher()

    var ciphers: [String: CipherProtocol] = [
        "Cesar": CesarCipher(),
        "Alpha": AlphanumbericCesarCipher(),
        "ROT-13": ROT_13_Cipher(),
        "ROT-5": ROT_5_Cipher(),
        // Add other ciphers here
    ]

    @IBAction func encryptButtonPressed(_ sender: Any) {
        guard
            let plaintext = inputField.text,
            let secretString = secretField.text
        else {
            output.text = "No values provided"
            return
        }
        output.text = cipher.encrypt(plaintext: plaintext, secret: secretString)
    }

    @IBAction func cipherSelected(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else{
            return
        }
        guard let selectedCipher = ciphers[buttonTitle] else {
            return
        }
        cipher = selectedCipher
    }
}
