import {
    Transfer as TransferEvent
} from "../generated/Card/Card"

import {
    log,
    ethereum,
    store,
    Bytes,
    Address,
    BigInt,
    Entity,
    Value,
    ValueKind
} from "@graphprotocol/graph-ts";

import { Card as CardContract } from "../generated/Card/Card"
import { Transfer } from "../generated/schema"

export class Card extends Entity {
    constructor(id: string) {
        super();
        this.set("id", Value.fromString(id));
    }

    save(): void {
        let id = this.get("id");
        assert(id != null, "Cannot save Card entity without an ID");
        if (id) {
            assert(
                id.kind == ValueKind.STRING,
                `Entities of type Card must have an ID of type String but the id '${id.displayData()}' is of type ${id.displayKind()}`
            );
            store.set("Card", id.toString(), this);
        }
    }

    static load(id: string): Card | null {
        return changetype<Card | null>(store.get("Card", id));
    }

    get id(): string {
        let value = this.get("id");
        return value!.toString();
    }

    set id(value: string) {
        this.set("id", Value.fromString(value));
    }

    get owner(): Bytes {
        let value = this.get("owner");
        return value!.toBytes();
    }

    set owner(value: Bytes) {
        this.set("owner", Value.fromBytes(value));
    }

    get image(): string {
        let value = this.get("image");
        return value!.toString();
    }

    set image(value: string) {
        this.set("image", Value.fromString(value));
    }

    get blockNumber(): BigInt {
        let value = this.get("blockNumber");
        return value!.toBigInt();
    }

    set blockNumber(value: BigInt) {
        this.set("blockNumber", Value.fromBigInt(value));
    }

    get blockTimestamp(): BigInt {
        let value = this.get("blockTimestamp");
        return value!.toBigInt();
    }

    set blockTimestamp(value: BigInt) {
        this.set("blockTimestamp", Value.fromBigInt(value));
    }

    get transactionHash(): Bytes {
        let value = this.get("transactionHash");
        return value!.toBytes();
    }

    set transactionHash(value: Bytes) {
        this.set("transactionHash", Value.fromBytes(value));
    }
}

export function handleTransfer(event: TransferEvent): void {
    let tokenId = event.params.tokenId;
    let contract = CardContract.bind(event.address);

    if (event.params.from.equals(Address.zero())) {
        let nft = new Card(tokenId.toString());
        nft.owner = event.params.to;
        nft.image = contract.getImage(tokenId);

        nft.blockNumber = event.block.number;
        nft.blockTimestamp = event.block.timestamp;
        nft.transactionHash = event.transaction.hash;

        nft.save();
    } else {
        let nft = Card.load(tokenId.toString());
        if (nft === null) {
            log.error('failed load NFT by token: {}', [tokenId.toString()]);
        } else {
            nft.owner = event.params.to;
            nft.image = contract.getImage(tokenId);
            nft.save();
        }
    }
}
