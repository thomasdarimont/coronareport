/*
 * Copyright 2020 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package quarano.core;

import lombok.EqualsAndHashCode;
import lombok.Getter;

import javax.persistence.EmbeddedId;
import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import javax.persistence.PostLoad;
import javax.persistence.PrePersist;
import javax.persistence.Transient;

import org.jddd.core.types.AggregateRoot;
import org.jddd.core.types.Identifier;
import org.springframework.data.domain.AbstractAggregateRoot;
import org.springframework.data.domain.Persistable;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.lang.NonNull;

/**
 * @author Oliver Drotbohm
 */
@MappedSuperclass
@EqualsAndHashCode(of = "id", callSuper = false)
@EntityListeners(AuditingEntityListener.class)
public abstract class QuaranoAggregate<T extends QuaranoAggregate<T, ID>, ID extends Identifier> //
		extends AbstractAggregateRoot<T> //
		implements AggregateRoot<T, ID>, Persistable<ID> {

	protected @Getter(onMethod = @__(@NonNull)) @EmbeddedId ID id;
	private @Getter AuditingMetadata metadata = new AuditingMetadata();
	private @Transient boolean isNew = true;

	public boolean hasId(ID id) {
		return this.id.equals(id);
	}

	/*
	 * (non-Javadoc)
	 * @see org.springframework.data.domain.Persistable#isNew()
	 */
	@Override
	public boolean isNew() {
		return isNew;
	}

	@PrePersist
	@PostLoad
	void markNotNew() {
		this.isNew = false;
	}
}
