require'rails_helper'
describe Contact do
  it "is valid with a firstname, lastname and email" do
    contact = Contact.new(
      firstname: "Thibault",
      lastname: "Finot",
      email: "thibault.finot@gmail.com")
    expect(contact).to be_valid
  end

  it "is invalid without a firstname" do
    contact = Contact.new(firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end

  it "is invalid without a lastname" do
    contact = Contact.new(lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end

  it "is invalid without an email address" do
    Contact.create(
      firstname: 'thib',
      lastname: "Fi",
      email: "thib@mail.co")
    contact = Contact.new(
      firstname: "hello",
      lastname: "Coucou",
      email: "thib@mail.co")
    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end

  it "is invalid with a duplicate email address" do
    Contact.create(
      firstname: "Thib",
      lastname: "Fi",
      email: "thib.fi@mail.fr"
      )
    contact = Contact.new(
      firstname: "Jacques",
      lastname: "Paulo",
      email: "thib.fi@mail.fr"
      )
    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end
  it "returns a contact's full name as a string" do
    contact = Contact.new(firstname: "Thib", lastname: "Fi", email: "thib@mail.fr")
    expect(contact.name).to eq "Thib Fi"
  end



  describe "filter last name by letter" do
    before :each do
      @smith = Contact.create(
        firstname: 'John',
        lastname: 'Smith',
        email: 'jsmith@example.com'
        )

      @jones = Contact.create(
        firstname: 'Tim',
        lastname: 'Jones',
        email: 'tjones@example.com'
        )

      @johnson = Contact.create(
        firstname: 'John',
        lastname: 'Johnson',
        email: 'jjohnson@example.com'
        )
    end

    context "with matching letters" do
      it "returns a sorted array of results that match" do
        expect(Contact.by_letter("J")).to eq [@johnson, @jones]
      end
    end
    context "non-matching letters" do
      it "omits results that do not match" do
        expect(Contact.by_letter("J")).not_to include @smith
      end
    end
  end
end
