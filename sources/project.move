module MyModule::DecentralizedLibrary {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing an educational resource.
    struct Resource has store, key {
        uploader: address,
        access_price: u64,
        total_earnings: u64,
    }

    /// Function to upload an educational resource with a set access price.
    public fun upload_resource(uploader: &signer, access_price: u64) {
        let resource = Resource {
            uploader: signer::address_of(uploader),
            access_price,
            total_earnings: 0,
        };
        move_to(uploader, resource);
    }

    /// Function for users to purchase access to a resource.
    public fun purchase_access(buyer: &signer, uploader_address: address) acquires Resource {
        let resource = borrow_global_mut<Resource>(uploader_address);

        // Buyer pays the access price
        let payment = coin::withdraw<AptosCoin>(buyer, resource.access_price);
        coin::deposit<AptosCoin>(uploader_address, payment);

        // Update total earnings for the uploader
        resource.total_earnings = resource.total_earnings + resource.access_price;
    }
}
